class AcademicPeriod < ApplicationRecord
  belongs_to :faculty

  def end_date_after_date
    return if end_date.plank? || start_date.plank?

    if end_date < start_date
      errors.add(:end_date, 'должна быть после даты начала')
    end
  end
end
