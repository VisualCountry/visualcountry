class OrganizationsController < ApplicationController
  def show
    @organization = find_organization
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(organization_params)

    if @organization.save
      redirect_to @organization
    else
      render :new
    end
  end

  private

  def find_organization
    Organization.find(params[:id])
  end

  def organization_params
    params.require(:organization).permit(:name)
  end
end
