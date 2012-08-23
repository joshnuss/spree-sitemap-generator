module SpreeSitemapGenerator::SpreeDefaults
  include ActionView::Helpers
  include ActionDispatch::Routing
  include Spree::Core::Engine.routes.url_helpers
  include Spree::BaseHelper # for gem_available?
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

    add(products_path, options.merge(:lastmod => active_products.last_updated))
    active_products.each do |product|
      add(product_path(product), options.merge(:lastmod => product.updated_at))
    end 
  end

  def add_pages(options={})
    # https://github.com/citrus/spree_essential_cms
    if gem_available? 'spree_essential_cms'
      Spree::Page.active.each do |page|
        add(page.path, options.merge(:lastmod => page.updated_at))
      end
    end
  end

  def add_taxons(options={})
    Spree::Taxon.roots.each {|taxon| add_taxon(taxon, options) }
  end

  def add_taxon(taxon, options={})
    add(nested_taxons_path(taxon.permalink), options.merge(:lastmod => taxon.products.last_updated))
    taxon.children.each {|child| add_taxon(child, options) }
  end

  def add_videos(options={})
    # https://github.com/iloveitaly/Spree-Videos
    if gem_available 'spree_videos'
      # TODO add video sitemap generation
    end
  end
end

