class OrganizationsController < ApplicationController
  layout 'application_with_sidebar'
  def show
    @organization = find_organization
    @available_lists = InfluencerList.all - @organization.influencer_lists
  end

  def index
    @organizations = Organization.all
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

  def edit
    @organization = find_organization
  end

  def update
    @organization = find_organization

    if @organization.update(organization_params)
      redirect_to @organization
    else
      render :edit
    end
  end

  def destroy
    organization = find_organization
    organization.destroy
    redirect_to organizations_path, alert: "\"#{organization.name}\" deleted!"
  end

  private

  def find_organization
    Organization.find(params[:id])
  end

  def organization_params
    params.require(:organization).permit(:name)
  end
end
