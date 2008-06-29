class InitialDatabase < ActiveRecord::Migration
  def self.up
    create_table "batches" do |t|
      t.string    "filename", "size", "content_type"
      t.datetime  "closed_at"
      t.timestamps
    end

    create_table "bandwidth_uses" do |t|
      t.integer "batch_id"
      t.string  "source", "request_method", "usage_type", "units"
      t.integer "amount"
      t.datetime "completed_at"
    end
    add_index "bandwidth_uses", ["batch_id"], :name => "index_bandwidth_use_batch_id"
  end

  def self.down
    remove_index "bandwith_uses", :name => "index_bandwidth_use_batch_id"
    drop_table "bandwidth_uses"

    drop_table "batches"
  end
end
