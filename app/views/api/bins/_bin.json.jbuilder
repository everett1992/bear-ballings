json.bin do
  json.courses bin.courses do |course|
    json.(course, :department, :title, :number)
  end
end

