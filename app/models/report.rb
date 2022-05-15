class Report < ApplicationRecord
  belongs_to :assignment

  after_initialize :set_default_status, if: :new_record?

  enum status: { ongoing: 0, done: 1 }

  private

  def set_default_status
    self.status ||= :ongoing
  end
end
