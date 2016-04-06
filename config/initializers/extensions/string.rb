# encoding: utf-8

String.class_eval do

  def to_sentences
    # Get a copy of the string.
    text = self.dup
    # Remove composite abbreviations.
    text.gsub!('et al.', '&&&')
    # Remove suspension points.
    text.gsub!('...', '&;&.')
    # Remove floating point numbers or number with points as seperator.
    text.gsub!(/(?:[0-9]+\.)/) { |abbr| abbr.gsub('.', '&@&') }
    # Handle floats without leading zero.
    text.gsub!(/\s\.([0-9]+)/) { ' &#&' + $1 }
    # Remove abbreviations.
    text.gsub!(/(?:[A-Za-z]\.){2,}/) { |abbr| abbr.gsub('.', '&-&') }
    # Remove initials.
    text.gsub!(/(?:[A-Z]\.)/) {|abbr| abbr.gsub('.', '&£&') }
    # Remove titles.
    text.gsub!(/[A-Z][a-z]{1,3}\./) { |title| title.gsub('.', '&*&') }
    # Unstick sentences from each other.
    text.gsub!(/([^.?!]\.|\!|\?)([^\s"'])/) { $1 + ' ' + $2 }
    # Remove html tags
    text.gsub!(/(\"|\s)\>\./, '$1$')
    # Remove sentence enders next to quotes.
    text.gsub!(/'([.?!])\s?"/) { '&^&' + $1 }
    text.gsub!(/'([.?!])\s?”/) { '&*&' + $1 }
    text.gsub!(/([.?!])\s?”/) { '&=&' + $1 }
    text.gsub!(/([.?!])\s?'"/) { '&,&' + $1 }
    text.gsub!(/([.?!])\s?'/) { '&%&' + $1 }
    text.gsub!(/([.?!])\s?"/) { '&$&' + $1 }
    # Remove sentence enders before parens.
    text.gsub!(/([.?!])\s?\)/) { '&€&' + $1 }
    # Split on any sentence ender.
    sentences = text.split(/([.!?])/)
    new_sents = []
    # Join the obtaine slices.
    sentences.each_slice(2) do |slice|
      new_sents << slice.join('')
    end
    # Restore the original text
    results = []
    new_sents.each do |sentence|
      # Skip whitespace zones.
      next if sentence.strip == ''
      # Restore composite abbreviations.
      sentence.gsub!('&&&', 'et al.')
      # Restore initials.
      sentence.gsub!("&£&", ".")
      # Restore abbreviations.
      sentence.gsub!('&-&', '.')
      # Restore titles.
      sentence.gsub!('&*&', '.')
      # Restore suspension points.
      sentence.gsub!('&;&.', '...')
      # Restore floats.
      sentence.gsub!('&@&', '.')
      # Restore html tags
      sentence.gsub!('$1$', '">.')
      # Restore quotes with sentence enders
      sentence.gsub!(/&=&([.!?])/) { $1 + '”' }
      sentence.gsub!(/&,&([.!?])/) { $1 + "'\"" }
      sentence.gsub!(/&%&([.!?])/) { $1 + "'" }
      sentence.gsub!(/&\^&([.?!])/) { "'" + $1 + '"' }
      sentence.gsub!(/&\*&([.?!])/) { "'" + $1 + '”' }
      sentence.gsub!(/&\$&([.!?])/) { $1 + '"' }
      # Restore parens with sentence enders
      sentence.gsub!(/&€&([.!?])/) { $1 + ')' }
      # Restore floats without leading zeros.
      sentence.gsub!(/&#&([0-9]+)/) { '.' + $1 }
      results << sentence.strip
    end
    results
  end
end