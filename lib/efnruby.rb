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
  
      def var(*options)
        access = options[-3..-1] & [:get, :set]
        options -= [:get, :set]
        klass = options.last.is_a?(Class) ? options.delete_at(-1) : BasicObject
        options.each do |name|
          create_var(name, access, klass)
        end
      end
      
      private
      def create_var(name, access, klass)
        if !access || access == []
          access = [:get, :set]
        end
        inst = :"@#{name}"
        if access.include? :get
          define_method name do
            instance_variable_get inst
          end
        end
        
        if access.include? :set
          define_method :"#{name}=" do |new_val|
            unless new_val.is_a? klass
              raise "Efn error! Can't set #{name} to a #{new_val.class.name}, only #{klass}"
            end
            instance_variable_set inst, new_val
          end
        end
      end
    end
  end
end

module EfnStrings
  def self.included(base)
    base.class_eval do
      def to_proc
        return Proc.new do |item|
          res = item
          self.split('.').map(&:to_sym).map(&:to_proc).each do |func|
            res = func.call res
          end
          res
        end
      end
    end
  end
end

module EfnArrays
  def self.included(base)
    base.class_eval do
      def to_proc
        return Proc.new do |item|
          res = item
          map(&:to_proc).each do |func|
            res = func.call res
          end
          res
        end
      end
    end
  end
end

BasicObject.send(:include, EfnRuby)
String.send(:include, EfnStrings)
Array.send(:include, EfnArrays)