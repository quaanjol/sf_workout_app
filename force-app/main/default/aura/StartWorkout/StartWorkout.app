<aura:application extends="force:slds" 
                  implements="force:appHostable,flexipage:availableForAllPageTypes,flexipage:availableForRecordHome,force:hasRecordId,forceCommunity:availableForAllPageTypes,force:hasSObjectName" 
                  access="global">
    <aura:attribute name="recordId" type="String"/>  
    <c:StartWorkoutCmp recordId="{!v.recordId}"/>
</aura:application>