class OrganizationListMembershipsController < ApplicationController
  def create
    organization = find_organization
    organization.add_list(find_list)
    redirect_to organization_path(find_organization)
  end

  def destroy
    membership = find_membership
    membership.destroy
    redirect_to organization_path(membership.organization)
  end

  private

  def find_organization
    Organization.find(organization_list_membership_params[:organization_id])
  end

  def find_list
    InfluencerList.find(organization_list_membership_params[:influencer_list_id])
  end

  def find_membership
    OrganizationListMembership.find(params[:id])
  end

  def organization_list_membership_params
    params.
      require(:organization_list_membership).
      permit(
        :influencer_list_id,
        :organization_id,
      )
  end
end
