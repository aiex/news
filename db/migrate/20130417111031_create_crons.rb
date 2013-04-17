class CreateCrons < ActiveRecord::Migration
  def change
    create_table :crons do |t|
      t.string :status, default: "Started"
      t.datetime :finished_at
      t.timestamps
    end
  end
end
