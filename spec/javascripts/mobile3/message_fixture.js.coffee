window.message_test_data = [
    id:            24
    text:          "Last Message."
    author:        "J. Doe"
    creation_date: "Jan-4 15:33"
  ,
    id:            23
    text:          "Middle Message."
    author:        "R. Smith"
    creation_date: "Jan-3 12:33"
    distributions: [
      {id: 33, member_id: 22, read: "yes", name: "X. Zang", rsvp: "NA"}
      ]
  ,
    id:            22
    text:          "First Message."
    author:        "R. Smith"
    creation_date: "Jan-2 09:33"
    rsvp_prompt:   "Do you see this?"
    rsvp_yes_prompt: "Yes I do"
    rsvp_no_prompt:  "No I don't"
    distributions: [
      {id: 34, member_id: 22, read: "yes", name: "X. Zang", rsvp: "no"}
      {id: 35, member_id: 23, read: "no",  name: "K. Did",  rsvp: "NONE"}
      ]
  ]

window.myid = 22
