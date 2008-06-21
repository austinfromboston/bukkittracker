class BatchesController < ApplicationController
  make_resourceful do
    actions :index, :new, :create, :show
  end
end
