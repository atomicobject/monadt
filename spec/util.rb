class Array
  def rest
    self[1..-1]
  end
end

class Lang
  def self.english
    ['zero', 'one', 'two', 'three', 'four', 'five']
  end
  def self.spanish
    ['cero', 'uno', 'dos', 'tres', 'quatro', 'cinco']
  end
end
