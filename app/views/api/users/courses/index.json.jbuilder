json.bins @bins do |bin|
  json.partial! '/api/bins/bin', bin: bin
end
