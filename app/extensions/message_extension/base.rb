module MessageExtension
  module Base

    def breakify(input)
      return input
      text = input.try(:clone) || ""
      text_index = 0
      max_length = 70
      while text[text_index..-1].length > max_length
        next_index = text[text_index..-1].index(' ') || text.length
        next_index = 1 if next_index == 0
        text.insert(text_index + max_length, ' ') if next_index > max_length
        text_index = next_index + text_index
      end
      text
    end

    def label4c
      label = ""
      label = rand((36**4)-1).to_s(36) until label.length == 4
      label
    end

  end
end
