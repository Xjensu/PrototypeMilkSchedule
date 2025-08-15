class ScheduleChange < ApplicationRecord
  belongs_to :schedule
  belongs_to :special_schedule
  belongs_to :academic_period
  belongs_to :student_group
  belongs_to :subject
  belongs_to :teacher
  belongs_to :classroom
  belongs_to :lesson
end
