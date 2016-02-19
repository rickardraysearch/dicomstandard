<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:d="http://docbook.org/ns/docbook"
	xmlns="http://www.pixelmed.com/namespaces/contextgroups"
	exclude-result-prefixes="d"
  	version="1.0">

<xsl:strip-space elements="*" />

<xsl:output omit-xml-declaration="no" method="xml" indent="yes" encoding="UTF-8" />

<xsl:template match="d:book">
	<!--<xsl:message>Matching book</xsl:message>-->
	<xsl:apply-templates match=""/>
</xsl:template>

<!-- do not want to match Section 7 explanatory tables -->
<xsl:template match="d:table[@label[starts-with(.,'TID ')] and not(@label[contains(.,'&lt;')]) and not(d:caption='Parameters')]">
	<xsl:message>Template <xsl:value-of select="@label"/></xsl:message>
	<xsl:choose>
		<xsl:when test="d:thead/d:tr/d:th[1] = ''
				    and d:thead/d:tr/d:th[2] = 'NL'
				    and d:thead/d:tr/d:th[3] = 'Rel with Parent'
				    and d:thead/d:tr/d:th[4] = 'VT'
				    and d:thead/d:tr/d:th[5] = 'Concept Name'
				    and d:thead/d:tr/d:th[6] = 'VM'
				    and d:thead/d:tr/d:th[7] = 'Req Type'
				    and d:thead/d:tr/d:th[8] = 'Condition'
				    and d:thead/d:tr/d:th[9] = 'Value Set Constraint'">
				
				<!-- process only top level content items, since each will then iterate through its own children, and so on recursively -->
				<xsl:for-each select="d:tbody/d:tr[string-length(normalize-space(d:td[2])) = 0]">
					<xsl:apply-templates select="." mode="groupnestinglevels"/>
				</xsl:for-each>
				
		</xsl:when>
		<xsl:when test="d:thead/d:tr/d:th[1] = ''
				    and d:thead/d:tr/d:th[2] = 'NL'
				    and d:thead/d:tr/d:th[3] = 'VT'
				    and d:thead/d:tr/d:th[4] = 'Concept Name'
				    and d:thead/d:tr/d:th[5] = 'VM'
				    and d:thead/d:tr/d:th[6] = 'Req Type'
				    and d:thead/d:tr/d:th[7] = 'Condition'
				    and d:thead/d:tr/d:th[8] = 'Value Set Constraint'">
		</xsl:when>
		<xsl:when test="d:thead/d:tr/d:th[1] = ''
				    and d:thead/d:tr/d:th[2] = 'VT'
				    and d:thead/d:tr/d:th[3] = 'Concept Name'
				    and d:thead/d:tr/d:th[4] = 'VM'
				    and d:thead/d:tr/d:th[5] = 'Req Type'
				    and d:thead/d:tr/d:th[6] = 'Condition'
				    and d:thead/d:tr/d:th[7] = 'Value Set Constraint'">
		</xsl:when>
		<xsl:otherwise>
			<xsl:message>No heading match <xsl:value-of select="@label"/></xsl:message>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="d:tr" mode="groupnestinglevels">
	<xsl:variable name="row"><xsl:value-of select="d:td[1]"/></xsl:variable>
	<xsl:if test="name(parent::node()) = 'tbody' and $row != ''">	<!-- untidy way to check not header, but it works :(; also excludes unlabelled rows-->
		<xsl:variable name="ourNestingLevel"><xsl:value-of select="string-length(normalize-space(d:td[2]))"/></xsl:variable>
		<xsl:variable name="relationship"><xsl:value-of select="normalize-space(d:td[3])"/></xsl:variable>
		<xsl:variable name="valueType"><xsl:value-of select="normalize-space(d:td[4])"/></xsl:variable>
		<xsl:variable name="conceptName"><xsl:value-of select="normalize-space(d:td[5])"/></xsl:variable>
		<xsl:variable name="vm"><xsl:value-of select="normalize-space(d:td[6])"/></xsl:variable>
		<xsl:variable name="requiredType"><xsl:value-of select="normalize-space(d:td[7])"/></xsl:variable>
		<xsl:variable name="condition"><xsl:value-of select="normalize-space(d:td[8])"/></xsl:variable>
		<xsl:variable name="valueSetConstraint"><xsl:value-of select="normalize-space(d:td[9])"/></xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$valueType != 'INCLUDE'">
					<xsl:message>Relationship <xsl:value-of select="$relationship"/> child value type <xsl:value-of select="$valueType"/></xsl:message>
		
					<!-- now recurse through all our immediate (only) children, so that they are enclosed with this templatecontentitem node -->
					<!--<xsl:message>Parent is <xsl:value-of select="preceding-sibling::d:tr[string-length(normalize-space(d:td[2])) &lt; string-length(normalize-space(current()/d:td[2]))][1]/d:td[1]"/></xsl:message>-->
					<!-- for-each d:tr that is an immediate child AND whose parent is us -->
					<xsl:variable name="ourid"><xsl:value-of select="generate-id(.)"/></xsl:variable>
					<xsl:for-each select="following-sibling::d:tr[string-length(normalize-space(d:td[2])) = ($ourNestingLevel + 1) and generate-id(preceding-sibling::d:tr[string-length(normalize-space(d:td[2])) = $ourNestingLevel][1]) = $ourid]">
						<xsl:message>Row <xsl:value-of select="d:td[1]"/></xsl:message>
						<xsl:message>Parent value type is <xsl:value-of select="$valueType"/></xsl:message>
						<xsl:apply-templates select="." mode="groupnestinglevels"/>
					</xsl:for-each>
					<!--<xsl:message>Closing row</xsl:message>-->
			</xsl:when>
			<xsl:otherwise>
					<xsl:message>Include <xsl:value-of select="$conceptName"/></xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
</xsl:template>

<xsl:template match="node()|@*|">
		<xsl:apply-templates match=""/>
</xsl:template>

<xsl:template match="text()"/>

</xsl:stylesheet>
