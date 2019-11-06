class Stock < ApplicationRecord
  belongs_to :item ,optional: true

  def self.takeinventory_find
    @this_year_beginning_product_inventory = TakeInventory.find_by(fiscal_year: @this_year)
    @prev_year_beginning_product_inventory = TakeInventory.find_by(fiscal_year: @prev_year)
  end
  def self.takeinventory_create
    @this_year = Date.today.year.to_s
    @prev_year = Date.today.prev_year.year.to_s
    #もし去年のTakeInventoryがなければ今年のTakeInventoryを作成(fiscal_yearに今年を入れておく)
    if @prev_year_beginning_product_inventory.nil? && @this_year_beginning_product_inventory.nil?
      record = TakeInventory.new(fiscal_year: @this_year)
      record.save
    #もし去年のデータがあって今年のデータが無かったら今年のデータを作成し作成日に今年を代入、去年のデータの期末商品棚卸高を今年の機種商品棚卸高に代入
    elsif @prev_year_beginning_product_inventory.present? && @this_year_beginning_product_inventory.nil?
      record = TakeInventory.new(fiscal_year: @this_year, beginning_product_inventory: @prev_year_beginning_product_inventory.period_end_product_inventory)
      record.save
    end
  end
end
