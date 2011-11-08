class MessageDecorator < ApplicationDecorator
  decorates :message

  def mobile_json
    fields = ["id", "author_id", "text"]
    hash = subset(model.attributes, fields)
    hash[:creation_date] = model.created_at.strftime("%b-%e %H:%M").gsub('- ','-') if model.created_at
    hash[:author_short_name] = model.author.try(:short_name)                       if model.author
    hash[:rsvp_prompt]       = model.rsvp.prompt                                   if model.rsvp
    hash[:rsvp_yes_prompt]   = model.rsvp.yes_prompt                               if model.rsvp
    hash[:rsvp_no_prompt]    = model.rsvp.no_prompt                                if model.rsvp

    dists = model.distributions.all.map do |dist|
      {
              :id         => "#{dist.id}",
              :message_id => "#{dist.message_id}",
              :member_id  => "#{dist.member_id}",
              :name       => dist.member.short_name,
              :read       => dist.read ? "yes" : "no",
              :rsvp       => model.rsvp ? (dist.rsvp_answer.try(:downcase) || "NONE") : "NA"
      }
    end
    hash[:distributions] = dists
    hash.to_json
  end

  def self.mobile_json
    result = Message.order('id DESC').limit(10).map do |m|
      MessageDecorator.new(m).mobile_json
    end.join(',')
    "[#{result}]"
  end

end