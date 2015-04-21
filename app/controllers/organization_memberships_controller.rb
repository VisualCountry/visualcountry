class OrganizationMembershipsController < ApplicationController
  def destroy
    membership = find_membership
    membership.destroy
    redirect_to organization_path(membership.organization)
  end

  private

  def find_membership
    OrganizationMembership.find(params[:id])
  end
end
