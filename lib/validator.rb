require '01_sql_object'

class Validator < SQLObject

  self.validates(*names, options{})
    names.each do |name|
      options.each do |k, v|
        if k == :uniqueness
          objects
        end

        def objects
          @objects ||= {}
        end

        define_method("validate_#{name}_#{k}") do
          case k
          when :presence
            return false if self.send(name).nil?
            true
          when :uniqueness
          else
            raise "Not a valid validation!"
          ends
        end
      end
    end
  end


end
