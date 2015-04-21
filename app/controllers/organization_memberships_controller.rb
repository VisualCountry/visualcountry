class OrganizationMembershipsController < ApplicationController
  def create
    user = find_user
    find_organization.add_user(user)
    redirect_to profile_path(user)
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

  def find_user
    User.find(organization_membership_params[:profile_id])
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
