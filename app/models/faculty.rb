class Faculty < ApplicationRecord
  validates :full_name, 
            presence: { message: "Полное название обязательно" },
            uniqueness: { message: "Факультет с таким названием уже существует" }
  
  validates :short_name, 
            presence: { message: "Сокращенное название обязательно" },
            uniqueness: { message: "Факультет с таким сокращением уже существует" },
            length: { minimum: 2, maximum: 4, 
                     too_short: "Минимум %{count} символа", 
                     too_long: "Максимум %{count} символа" }
end