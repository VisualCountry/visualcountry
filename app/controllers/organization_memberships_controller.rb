class OrganizationMembershipsController < ApplicationController
  def create
    profile = find_profile
    find_organization.add_profile(profile)
    redirect_to profile_path(profile)
  end

  def destroy
    membership = find_membership
    membership.destroy
    redirect_to organization_path(membership.organization)
  end

  private

  def find_membership
    OrganizationMembership.find(params[:id])
  end

  def find_profile
    Profile.find(organization_membership_params[:profile_id])
  end

  def find_organization
    Organization.find(organization_membership_params[:organization_id])
  end

  def organization_membership_params
    params.
      require(:organization_membership).
      permit(
        :organization_id,
        :profile_id,
      )
  end
end
