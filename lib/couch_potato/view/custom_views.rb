require File.dirname(__FILE__) + '/base_view_spec'
require File.dirname(__FILE__) + '/model_view_spec'
require File.dirname(__FILE__) + '/properties_view_spec'
require File.dirname(__FILE__) + '/custom_view_spec'
require File.dirname(__FILE__) + '/raw_view_spec'


module CouchPotato
  module View
    module CustomViews

      def self.included(base) #:nodoc:
        base.extend ClassMethods
      end

      module ClassMethods
        def views(view_name = nil) #:nodoc:
          if view_name
            _find_view(view_name)
          else
            @views ||= {}
          end
        end

        def execute_view(view_name, view_parameters) #:nodoc:
          view_spec_class(views(view_name)[:type]).new(self, view_name, views(view_name), view_parameters)
        end
        
        # Declare a CouchDB view, for examples on how to use see the *ViewSpec classes in CouchPotato::View
        def view(view_name, options)
          view_name = view_name.to_s
          views[view_name] = options
          method_str = "def #{view_name}(view_parameters = {}); execute_view(\"#{view_name}\", view_parameters); end"
          self.instance_eval(method_str)
        end

        def view_spec_class(type) #:nodoc:
          if type && type.is_a?(Class)
            type
          else
            name = type.nil? ? 'Model' : type.to_s.camelize
            CouchPotato::View.const_get("#{name}ViewSpec")
          end
        end
        
        def _find_view(view) #:nodoc:
          return @views[view] if @views && @views[view]
          superclass._find_view(view) if superclass && superclass.respond_to?(:_find_view)
        end
      end
    end
  end
end
