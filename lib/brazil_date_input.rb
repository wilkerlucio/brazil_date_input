# BrazilDateInput

module BrazilDateInput
  def self.included(base)
    base.send :extend, ClassMethods
  end
  
  module ClassMethods
    def brazil_date_field *args
      args.each do |field|
        field_name = "#{field}_bd"
        
        define_method field_name do
          if send(field).blank?
            nil
          else
            send(field).to_s.split('-').reverse.join('/')
          end
        end
        
        define_method "#{field_name}=" do |date|
          return unless date =~ /\d{2}\/\d{2}\/\d{4}/
          
          send("#{field}=", date.split('/').reverse.join('-'))
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

ActiveRecord::Base.send :include, BrazilDateInput
