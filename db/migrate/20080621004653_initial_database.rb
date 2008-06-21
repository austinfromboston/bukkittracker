class InitialDatabase < ActiveRecord::Migration
  def self.up
    create_table "batches" do |t|
      t.string    "filename"
      t.datetime  "closed_at"
      t.timestamps
    end

    create_table "bandwidth_usages" do |t|
      t.integer "batch_id"
      t.string  "source", "action", "units"
      t.integer "amount"
      t.datetime "completed_at"
    end
    add_index "bandwidth_usages", ["batch_id"], :name => "index_bandwidth_usage_batch_id"
  end

  def self.down
    remove_index "bandwith_usages", :name => "index_bandwidth_usage_batch_id"
    drop_table "bandwidth_usages"

    drop_table "batches"
  end
end
