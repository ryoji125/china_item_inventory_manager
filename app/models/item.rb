class Item < ApplicationRecord
  has_many :stocks, dependent: :destroy
  validates :simulate_price, numericality: true

  def self.search(search) #self.でクラスメソッドとしている
    if search # Controllerから渡されたパラメータが!= nilの場合は、titleカラムを部分一致検索
      Item.where('item_title LIKE ? OR part_number LIKE ?', "%#{search}%", "%#{search}%")
    end
  end

  def self.import(file)
    CSV.foreach(file.path,encoding: "Shift_JIS:UTF-8",headers: true) do |row|
      item=new
      # CSVからデータを取得し、設定する
      item.attributes = row.to_hash.slice(*updatable_attributes)
      # 保存する
      if item.save
        @proccesinng=1
      else
        @proccesinng=2
      end
    end
  end

  # 更新を許可するカラムを定義
  def self.updatable_attributes
    ["item_title", "part_number", "simulate_price","item_picture"]
  end
  #インポートできたどうかをコントローラーに渡すためのメソッド
  def self.get_processing
    @proccesinng
  end

end
