def rand2() srand.to_s[0..1]; end
def rand3() srand.to_s[0..2]; end
def rand4() srand.to_s[0..3]; end
def randM() 1 + rand(12); end
def randD() 1 + rand(28); end
def randE() "2011-#{randM}-#{randD}"; end

Factory.define :action do |u|
  u.kind        "event" 
  u.title       { "T#{rand4}" }
  u.location    { "L#{rand4}" } 
  u.leaders     { "Leader#{rand4}" }
  u.start       { randE }
  u.finish
  u.description { "Big Hello #{rand4}" }
end

