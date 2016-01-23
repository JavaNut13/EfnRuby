module EfnRuby
  def self.included(base)
    base.class_eval do
      def sfn(name, &block)
        self.class.send(:define_method, name, block)
      end
  
      def fn(name, type=:inst, &block)
        if type == :static
          self.class.send(:define_method, name, block)
        else
          define_method name, block
        end
      end
  
      def var(name, *options)
        if options.include? :get
          if options.include? :set
            attr_accessor name
          else
            attr_reader name
          end
        elsif options.include? :set
          attr_writer name
        else
          attr_accessor name
        end
      end
    end
  end
end

BasicObject.send(:include, EfnRuby)