class Task < ActiveRecord::Base
  validates_presence_of :name, :description

  def closed?
    closes_at.past?
  end
end
