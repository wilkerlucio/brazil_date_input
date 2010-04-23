# BrazilDateInput

module BrazilDateInput
  def self.included(base)
    base.send :extend, ClassMethods
  end
  
  module ClassMethods
    def brazil_date_field *args
      args.each do |field|
        field_name = "#{field}_br"
        
        define_method field_name do
          if send(field).blank?
            nil
          else
            send(field).strftime("%d/%m/%Y")
          end
        end
        
        define_method "#{field_name}=" do |date|
          return unless date =~ /\d{2}\/\d{2}\/\d{4}/
          
          send("#{field}=", Date.strptime(date, "%d/%m/%Y"))
        end
      end
    end
    
    def brazil_datetime_field *args
      args.each do |field|
        field_name = "#{field}_br"

        define_method field_name do
          if send(field).blank?
            nil
          else
            send(field).strftime("%d/%m/%Y %H:%M")
          end
        end

        define_method "#{field_name}=" do |date|
          return unless date =~ /^\d{2}\/\d{2}\/\d{4} \d{2}:\d{2}$/

          send("#{field}=", DateTime.strptime(date + "-0300", "%d/%m/%Y %H:%M%Z"))
        end
      end
    end
    
    def age_calculation_field(date_field, target_field = :age)
      define_method target_field do
        cur = send(date_field)
        return 0 if cur.blank?

        now = DateTime.now
        old = now.year - cur.year
        old -= 1 if (now.month < cur.month or (now.month == cur.month and now.day < cur.day))

        old
      end
    end
  end
end

ActiveRecord::Base.send :include, BrazilDateInput if defined? ActiveRecord
Mongoid::Document::ClassMethods.send :include, BrazilDateInput::ClassMethods
