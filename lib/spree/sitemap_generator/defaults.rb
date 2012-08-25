module Spree
  module SitemapGenerator
    module Defaults
      include ActionView::Helpers
      include ActionDispatch::Routing
      include Spree::Core::Engine.routes.url_helpers
      include Spree::BaseHelper # for gem_available? + meta_data
      include Rails.application.routes.url_helpers

      def default_url_options
        { :host => SitemapGenerator::Sitemap.default_host }
      end 

      def add_login(options={})
        add(login_path, options)
      end

      def add_signup(options={})
        add(signup_path, options)
      end

      def add_account(options={})
        add(account_path, options)
      end

      def add_password_reset(options={})
        add(new_user_password_path, options)
      end

      def add_products(options={})
        active_products = Spree::Product.active

        add(products_path, options.merge(:lastmod => last_updated(active_products)))

        active_products.each do |product|
          opts = options.merge(:lastmod => product.updated_at, :priority => priority(product))

          if gem_available? 'spree_videos' and product.videos.present?
            @video_exclude ||= []

            # TODO auto creating an exclusion list should be a config option
            # better to only show a video on the primary page related to the video
            # https://sites.google.com/site/webmasterhelpforum/en/faq-video-sitemaps#multiple-pages
            # @video_exclude += product.videos.map(&:youtube_ref)

            video_list = product.videos.select { |v| !@video_exclude.include? v.youtube_ref }.map do |v|
              video_options(v.youtube_ref, product)
            end

            opts.merge!(:video => video_list) if video_list.present?
          end

          add(product_path(product), opts)
        end 
      end

      def add_pages(options={})
        # TODO this should be refactored to add_pages & add_page

        # https://github.com/citrus/spree_essential_cms
        Spree::Page.active.each do |page|
          add(page.path, options.merge(:lastmod => page.updated_at, :priority => priority(page)))
        end if gem_available? 'spree_essential_cms'
      end

      def add_taxons(options={})
        Spree::Taxon.roots.each {|taxon| add_taxon(taxon, options) }
      end

      def add_taxon(taxon, options={})
        opts = options.merge(:lastmod => last_updated(taxon.products), :priority => priority(taxon))

        if gem_available? 'spree_taxon_splash' and taxon.taxon_splash.present?
          @video_exclude ||= []

          # TODO currently only supports one match... should extend to match multiple videos embedded in page
          # TODO only supports URL of style http://www.youtube.com/embed/DshOrgcEKsQ

          # pattern taken from: https://github.com/iloveitaly/Spree-Videos/blob/master/app/models/spree/video.rb#L10

          youtube_ref = taxon.taxon_splash.content.match(/youtube\.com\/embed(v=|\/)([\w-]+)(&.+)?/) { |m| m[2] }

          if youtube_ref.present? and !@video_exclude.include? youtube_ref
            # taxon splash pages would always hold primacy over a product (at least in my use case)
            @video_exclude << youtube_ref

            opts.merge! :video => video_options(youtube_ref, taxon)
          end
        end

        add(nested_taxons_path(taxon.permalink), opts)
        taxon.children.each {|child| add_taxon(child, options) }
      end

      private
        def video_options(youtube_id, object = false)
          # https://github.com/iloveitaly/Spree-Videos
          # multiple videos of the same ID can exist, but all videos linked in the sitemap should be inique

          # required video fields are outlined here: http://www.seomoz.org/blog/video-sitemap-guide-for-vimeo-and-youtube
          # youtube thumbnail images: http://www.reelseo.com/youtube-thumbnail-image/

          # NOTE title should match the page title, however the title generation isn't self-contained
          # although not a future proof solution, the best (+ easiest) solution is to mimic the title for product pages
          #   https://github.com/spree/spree/blob/master/core/lib/spree/core/controller_helpers.rb#L38
          #   https://github.com/spree/spree/blob/master/core/app/controllers/spree/products_controller.rb#L33

          ({ :description => meta_data(object)[:description] } rescue {}).merge(
            ({ :title => [Spree::Config[:site_name], object.name].join(' - ') } rescue {})
          ).merge({
            :thumbnail_loc => "http://img.youtube.com/vi/#{youtube_id}/0.jpg",
            :player_loc => "http://www.youtube.com/v/#{youtube_id}",
            :autoplay => "ap=1"
          })
        end

        # override via class eval
        def priority(object)
          0.5
        end

        def last_updated(object)
          if object.is_a? ActiveRecord::Relation
            return object.order('updated_at DESC').first.try :updated_at
          elsif object.kind_of? ActiveRecord::Base
            return object.last_updated
          end

          Time.now
        end
    end
  end
end

