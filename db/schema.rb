# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080621004653) do

  create_table "bandwidth_uses", :force => true do |t|
    t.integer  "batch_id"
    t.string   "source"
    t.string   "request_method"
    t.string   "usage_type"
    t.string   "units"
    t.integer  "amount"
    t.datetime "completed_at"
    t.datetime "started_at"
  end

  add_index "bandwidth_uses", ["batch_id"], :name => "index_bandwidth_use_batch_id"

  create_table "batches", :force => true do |t|
    t.string   "filename"
    t.string   "size"
    t.string   "content_type"
    t.datetime "closed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
