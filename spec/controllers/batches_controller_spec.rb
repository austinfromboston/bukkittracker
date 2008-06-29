require File.dirname(__FILE__) + '/../spec_helper'

describe BatchesController do
  describe "GET #index" do
    act!{ get :index }
    it_renders :template, :index
    it_assigns :batches
  end
  describe "GET #new" do
    act!{ get :new }
    it_renders :template, :new
    it_assigns :batch
  end
  describe "POST #create" do
    act!{ post :create }
    it_assigns :batch
  end

  describe "GET #show" do
    before do
      Batch.stub!(:find).and_return(new_batch)
    end
    act!{ get :show, :id => 1 }
    it_renders :template, :show
    it_assigns :batch

    describe "responds to csv format" do
      act!{ get :show, :id => 1, :format => 'csv' }
      it_assigns :csv_output
    end
  end
end
