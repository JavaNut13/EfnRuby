# 'Efn Ruby

_Make Ruby weird_

    fn :my_method do |args|
      puts args.inspect
    end

Will define a method called `my_method`. You can call this like you normally would.

    class MyObject
      fn :class_method, :static do |arg|
        puts arg
      end
      
      fn :instance_method do |arg|
        puts arg
      end
    end
    
Defines a static method and an instance method on `MyObject`. These can be accessed normally too:

    MyObject.class_method(5)
    # => 5
    obj = MyObject.new
    obj.instance_method('things')
    # => 'things'

You can also define variables:

    class MyObject
      var :name # equivalent to attr_accessor
      var :reader_only, :get # attr_reader
      var :writer_only, :set # attr_writer
    end
    
Wooo! Metaprogramming!
        