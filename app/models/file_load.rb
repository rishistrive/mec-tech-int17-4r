require 'csv'
class FileLoad < ApplicationRecord
  validates :filename, presence: true
  validate :validate_file_exists, if: :filename
  serialize :results, Hash
  
  ## File Format ##
  FILEFORMAT = ['food-vendors', 'service-vendors']
  ## File Format ##

  def full_path
    File.join(Rails.root,filename)
  end
  
  def validate_file_exists
    unless File.exist?(full_path)
      errors.add(:filename, "not found")
    end
  end
  
  before_create :load_file
  
  def load_file
    result_rows = []
    row_count = 0
    CSV.foreach(full_path, headers: true) do |row|
      row_count += 1
      code = ''
      food_type = ''
      if self.file_format == FILEFORMAT[0]
        code = row["Merchant Code"]
        food_type = row["Food Type"]
      else
        code =  row["Merchant Group"] +'-'+ row["Member ID"]
        food_type =  row["Service Category"].humanize +'-'+ row["Services Detail"].humanize
      end

      result_rows << {
        village: row["Village"], 
        code: code, 
        name: row["Merchant Name"],
        food_type: food_type
      }

      ## Saving data to food shop here ##
      if row["Merchant Code"].present? && row["Merchant Name"].present?
        FoodShop.create(
          village: row["Village"], 
          code: code, 
          name: row["Merchant Name"],
          food_type: food_type
        )
      end
      ## Saving data to food shop here ##
    end
    self.results = {row_count: row_count, rows: result_rows}
  end
  
end
