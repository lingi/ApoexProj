class CompaniesController < ActionController::Base
  # GET /companies
  def index
    begin
      @companies = SearchAllaBolag.search(params[:query]) #get query (from search_alla_bolag.rb)
    rescue Exception => e
      Rails.logger.info( e.message )
      @error = e.message
    end
    respond_to do |format|  #Rails method for responding to particular request types
      format.html #if the client wants html, just return the same
      format.json { render json: @companies, only: [:identification_no, :name]} #return with json
      format.xml { render xml: @companies, only: [:identification_no, :name]}   #return with xml
     end
  end
end
