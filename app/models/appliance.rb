class Appliance < ActiveRecord::Base
  ACTIONS = {:create => 'CREATE', :destroy => 'DESTROY'}
  STATUSES = {:new => 'NEW', :created => 'CREATED', :error => 'ERROR', :removed => 'REMOVED', :removing => 'REMOVING'}

  has_many :images

  validates_presence_of :name, :summary, :config

  def self.definitions
    @@definitions = {}
    Appliance.all(:select => "name, status, config") { |appliance| @@definitions[appliance.name] = appliance.config.definition }

    @@definitions
  end

  def self.add_definition(name, definition)
    @@definitions[name] = definition
  end

  after_initialize do
    if self.status.nil?
      self.status = STATUSES[:new]
      self.created_at = self.updated_at = Time.now
    end
  end
end