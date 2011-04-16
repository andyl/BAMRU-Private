10.times { Factory(:action, :kind => "meeting")                    }
7.times  { Factory(:action, :kind => "training")                   }
3.times  { Factory(:action, :kind => "event")                      }
3.times  { Factory(:action, :kind => "non_county")                 }

3.times  { Factory(:action, :kind => "training",   :end => randE ) }
2.times  { Factory(:action, :kind => "event",      :end => randE ) }
