class BatchesController < ApplicationController
  make_resourceful do
    actions :index, :new, :create, :show
    response_for :show do |format|
      format.html {}
      format.csv do
        @csv_output = FasterCSV.generate do |csv|
          csv << [ 'Bucket', 'Status', 'Qty', 'Charges' ]
          unless params[:query] == 'billable'
            Bukkit.bucket_qtys( @batch.entries.internal ).each do |bucket, qty|
              quantities = Bukkit::S3.quantities( @batch.entries.by_source( bucket ) )
              expenses = Bukkit::S3.expenses( @batch.entries.by_source( bucket ) )
              csv << [ bucket, 'internal', qty, expenses[:all] ] 
            end
          end
          Bukkit.bucket_qtys( @batch.entries.billable ).each do |bucket, qty|
            quantities = Bukkit::S3.quantities( @batch.entries.by_source( bucket ) )
            expenses = Bukkit::S3.expenses( @batch.entries.by_source( bucket ) )
            csv << [ bucket, 'billable', qty, expenses[:all] ] 
          end
        end
        render :text => @csv_output
      end

    end
  end
end
