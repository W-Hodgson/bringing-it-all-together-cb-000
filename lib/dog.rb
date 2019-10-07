class Dog

  attr_accessor :name, :breed, :id

  def initialize(name:, id:nil, breed:)
    @name = name
    @id = id
    @breed = breed
  end

  def self.create_table
    DB[:conn].execute("CREATE TABLE IF NOT EXISTS dogs(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, breed TEXT)")
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE dogs")
  end

  def self.new_from_db(row)
    dog = self.new(id: row[0], name: row[1], breed: row[2])
    dog
  end

  def save
    DB[:conn].execute("INSERT INTO dogs(name, breed) VALUES (?, ?)", @name, @breed)

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    self
  end

  def self.create(name:, breed:)
    dog = self.new(name: name, breed: breed)
    dog.save
  end

  def self.find_by_id(id)
    DB[:conn].execute("SELECT * FROM dogs WHERE id = ?", id).map do |dog|
      self.new_from_db(dog)
    end.first
  end

  def self.find_or_create_by(dog)
    DB[:conn].execute("SELECT * FROM dogs WHERE name = ? and breed = ?", dog["name"], dog["breed"])[0]
  end

end
