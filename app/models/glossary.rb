class Glossary < ApplicationRecord
  ALPHABET = ('a'..'z').to_a.insert(0, '#')

  scope :order_alphabet, -> (char) {
    if char == '#'
      where("title regexp '^[0-9]'")
    else
      where("title like ?", "#{char}%")
    end
  }
end
