module SpreeSitemapGenerator
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_sitemap_generator'

    config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      ActiveRecord::Relation.class_eval do
        def last_updated
          last_update = order('updated_at DESC').first
          last_update.try(:updated_at) 
        end 
      end

      ActiveRecord::Base.class_eval do
        def self.last_updated
          scoped.last_updated
        end
      end

      SitemapGenerator::Interpreter.send :include, Spree::SitemapGenerator::Defaults
    end

    config.to_prepare &method(:activate).to_proc
  end
end
