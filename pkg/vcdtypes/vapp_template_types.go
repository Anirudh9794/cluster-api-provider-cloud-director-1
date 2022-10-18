package vcdtypes

// QueryResultVappTemplateType represents a vApp template as query result
type QueryResultVappTemplateType struct {
	HREF               string    `xml:"href,attr,omitempty"`               // The URI of the entity.
	ID                 string    `xml:"id,attr,omitempty"`                 // vApp template ID.
	Type               string    `xml:"type,attr,omitempty"`               // The MIME type of the entity.
	OwnerName          string    `xml:"ownerName,attr,omitempty"`          // Owner name
	CatalogName        string    `xml:"catalogName,attr,omitempty"`        // Catalog name
	IsPublished        bool      `xml:"isPublished,attr,omitempty"`        // True if this entity is in a published catalog
	Name               string    `xml:"name,attr,omitempty"`               // vApp template name.
	Description        string    `xml:"description,attr,omitempty"`        // vApp template description.
	Vdc                string    `xml:"vdc,attr,omitempty"`                // VDC reference or ID
	VdcName            string    `xml:"vdcName,attr,omitempty"`            // VDC name
	Org                string    `xml:"org,attr,omitempty"`                // Organization reference or ID
	CreationDate       string    `xml:"creationDate,attr,omitempty"`       // Creation date
	IsBusy             bool      `xml:"isBusy,attr,omitempty"`             // True if the vApp template is busy
	IsGoldMaster       bool      `xml:"isGoldMaster,attr,omitempty"`       // True if the vApp template is a gold master
	IsEnabled          bool      `xml:"isEnabled,attr,omitempty"`          // True if the vApp template is enabled
	Status             string    `xml:"status,attr,omitempty"`             // Status
	IsDeployed         bool      `xml:"isDeployed,attr,omitempty"`         // True if this entity is deployed
	IsExpired          bool      `xml:"isExpired,attr,omitempty"`          // True if this entity is expired
	StorageProfileName string    `xml:"storageProfileName,attr,omitempty"` // Storage profile name
	Version            string    `xml:"version,attr,omitempty"`            // Storage profile name
	LastSuccessfulSync string    `xml:"lastSuccessfulSync,attr,omitempty"` // Date of last successful sync
	Link               *Link     `xml:"Link,omitempty"`
	Metadata           *govcd.Metadata `xml:"Metadata,omitempty"`
}
