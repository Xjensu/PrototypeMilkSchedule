
[ :lecture, :pz, :lab, :test, :exam, :under ].each do |type|
  Lesson.create!(lesson_type: type)
end

User.create(email: 'testadmin@gmail.com', password: 'password')