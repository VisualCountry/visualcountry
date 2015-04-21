class OrganizationsController < ApplicationController
  def show
    @organization = find_organization
  end

  private

  def find_organization
    Organization.find(params[:id])
  end
end
