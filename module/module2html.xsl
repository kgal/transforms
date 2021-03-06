<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cc="https://niap-ccevs.org/cc/v1"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:htm="http://www.w3.org/1999/xhtml"
  version="1.0">

  <xsl:import href="../pp2html.xsl"/>

  <xsl:output method="xml" encoding="UTF-8"/>

  <!-- Directory where the base PPs currently reside (with the names 0.xml, 1.xml,...)-->
  <xsl:param name="basesdir"/>
  
  <!-- Value on whether this is the formal release build -->
  <xsl:param name="release" select="final"/>

  <!-- ################################################## -->
  <!--                   Templates Section                -->
  <!-- ################################################## -->
  <xsl:template match="cc:Module">
    <xsl:apply-templates select="//cc:chapter[@title='Introduction']"/>
    <xsl:apply-templates select="//cc:chapter[@title='Conformance Claims']"/>
    <xsl:apply-templates select="//cc:chapter[@title='Security Problem Description']"/>
    <xsl:apply-templates select="//cc:chapter[@title='Security Objectives']"/>
    <xsl:apply-templates select="//cc:chapter[@title='Security Requirements']"/>
    <xsl:call-template name="consistency-rationale"/>
    <xsl:call-template name="opt-sfrs"/>
    <xsl:call-template name="sel-sfrs"/>
    <xsl:call-template name="obj-sfrs"/>
    <xsl:apply-templates select="//cc:bibliography"/>
    <xsl:apply-templates select="//cc:acronyms"/>
    <xsl:apply-templates select="//cc:appendix"/>
  </xsl:template>



  <xsl:template match="/cc:Module//cc:chapter[@title='Security Requirements']">
    <h1 id="{@id}" class="indexable" data-level="1"><xsl:value-of select="@title"/></h1>
    <xsl:call-template name="secrectext"/>
    <xsl:apply-templates/>
    <xsl:call-template name="man-sfrs"/>
  </xsl:template>

  <xsl:template name="consistency-rationale">
    <h1 id="mod-conrat" class="indexable" data-level="1">Consistency Rationale</h1>

    <xsl:for-each select="//cc:base-pp">
      <xsl:variable name="base" select="."/>

      <h2 id="conrat-{@short}" class="indexable" data-level="2">
	<xsl:value-of select="@name"/> Protection Profile
      </h2>

      <!-- #################### -->
      <h3 id="contoe-{@short}" class="indexable" data-level="3">
	Consistency of TOE Type
      </h3>
      <xsl:apply-templates select="./cc:con-toe"/>

      <!-- #################### -->
      <h3 id="consecprob-{@short}" class="indexable" data-level="3">
	Consistency of Security Problem Definition
      </h3>
      The threats defined by this PP-Module (see section 3.1) supplement those defined in the
      <xsl:value-of select="@short"/> PP as follows:
      <xsl:apply-templates select="./cc:con-sec-prob"/>
      <table><tr><th>PP-Module Threat</th><th>Consistency Rationale</th></tr>
      <xsl:for-each select="//cc:threat">
	<xsl:call-template name="consistency-row">
	  <xsl:with-param name="base" select="$base"/>
	  <xsl:with-param name="orig" select="."/>
	</xsl:call-template>
      </xsl:for-each>
      </table>

      <!-- #################### -->
      <h3 id="conobj-{@short}" class="indexable" data-level="3">
	Consistency of Objectives
      </h3>
      <p>
      <xsl:apply-templates select="./cc:con-obj"/>
      <xsl:if test="//cc:SO">
	  The objectives for the TOEs are consistent with the <xsl:value-of select="$base/@short"/> PP based on the following rationale:
      <table><tr><th>PP-Module Threat</th><th>Consistency Rationale</th></tr>
      <xsl:for-each select="//cc:SO">
	<xsl:call-template name="consistency-row">
	  <xsl:with-param name="base" select="$base"/>
	  <xsl:with-param name="orig" select="."/>
	</xsl:call-template>
      </xsl:for-each>
      </table>
      </xsl:if>
      </p>

      <p>
      <xsl:apply-templates select="./cc:con-op-en"/>
      <xsl:if test="//cc:SOE">
	  The objectives for the TOE's operational environment are consistent with the <xsl:value-of select="$base/@short"/> PP based on the following rationale:
      <table><tr><th>PP-Module Threat</th><th>Consistency Rationale</th></tr>
      <xsl:for-each select="//cc:SOE">
	<xsl:call-template name="consistency-row">
	  <xsl:with-param name="base" select="$base"/>
	  <xsl:with-param name="orig" select="."/>
	</xsl:call-template>
      </xsl:for-each>
      </table>
      </xsl:if>
      </p>

      <h3 id="conreq-{@short}" class="indexable" data-level="3">
	Consistency of Requirements
      </h3>
      <xsl:apply-templates select="./cc:con-req"/>
      This PP-Module identifies several SFRs from the 
      <xsl:value-of select="$base/@short"/> PP that are needed to support 
      <xsl:value-of select="/cc:Module/@target-products"/> functionality.
      This is considered to be consistent because the functionality provided by the 
      <xsl:value-of select="$base/@short"/>  is being used for its intended purpose.
      The PP-Module also identifies a number of modified SFRs from the 
      <xsl:value-of select="$base/@short"/> PP
      as well as new SFRs that are used entirely to provide 
      <xsl:value-of select="/cc:Module/@target-products"/> 
      The rationale for why this does not conflict with the claims 
      defined by the 
      <xsl:value-of select="$base/@short"/> PP are as follows:
      <table>
	<tr><th>PP-Module Requirement</th><th>Consistency Rationale</th></tr>
	<tr> <th colspan="2"> Modified SFRs</th></tr>
	<xsl:call-template name="req-con-rat-sec">
	  <xsl:with-param name="f-comps" select="$base/cc:modified-sfrs//cc:f-component"/>
	  <xsl:with-param name="short" select="$base/@short"/>
	  <xsl:with-param name="none-msg">
	    This PP-Module does not modify any requirements when the 
	    <xsl:value-of select="$base/@short"/> PP is the base.
	  </xsl:with-param>
	</xsl:call-template>
	<tr>
	  <th colspan="2"> Additional SFRs</th>
	</tr>
	<xsl:call-template name="req-con-rat-sec">
	  <xsl:with-param name="f-comps" select="$base/cc:additional-sfrs//cc:f-component"/>
	  <xsl:with-param name="short" select="$base/@short"/>
	  <xsl:with-param name="none-msg">
	    This PP-Module does not add any requirements when the 
	    <xsl:value-of select="$base/@short"/> PP is the base.
	  </xsl:with-param>
	</xsl:call-template>

	<tr>
	  <th colspan="2"> Mandatory SFRs</th>
	  <xsl:call-template name="req-con-rat-sec">
	    <xsl:with-param name="f-comps" select="//cc:man-sfrs//cc:f-component"/>
	    <xsl:with-param name="short" select="$base/@short"/>
	    <xsl:with-param name="none-msg">
	      This PP-Module does not define any mandatory requirements.
	    </xsl:with-param>
	  </xsl:call-template>
	</tr>
	<tr>
	  <th colspan="2"> Optional SFRs</th>
	  <xsl:call-template name="req-con-rat-sec">
	    <xsl:with-param name="f-comps" select="//cc:opt-sfrs//cc:f-component"/>
	    <xsl:with-param name="short" select="$base/@short"/>
	    <xsl:with-param name="none-msg">
	      This PP-Module does not define any optional requirements.
	    </xsl:with-param>
	  </xsl:call-template>
	</tr>
	<tr>
	  <th colspan="2"> Selection-based SFRs</th>
	  <xsl:call-template name="req-con-rat-sec">
	    <xsl:with-param name="f-comps" select="//cc:sel-sfrs//cc:f-component"/>
	    <xsl:with-param name="short" select="$base/@short"/>
	    <xsl:with-param name="none-msg">
	      This PP-Module does not define any selection-based requirements.
	    </xsl:with-param>
	  </xsl:call-template>
	</tr>
	<tr>
	  <th colspan="2"> Objective SFRs</th>
	  <xsl:call-template name="req-con-rat-sec">
	    <xsl:with-param name="f-comps" select="//cc:obj-sfrs//cc:f-component"/>
	    <xsl:with-param name="short" select="$base/@short"/>
	    <xsl:with-param name="none-msg">
	      This PP-Module does not define any objective requirements.
	    </xsl:with-param>
	  </xsl:call-template>
	</tr>


      </table>
    </xsl:for-each> <!-- End base iteration -->
  </xsl:template>


  <xsl:template name="req-con-rat-sec">
    <xsl:param name="f-comps"/>
    <xsl:param name="short"/>
    <xsl:param name="verb"/>
    <xsl:param name="none-msg"/>
    <xsl:choose>
      <xsl:when test="$f-comps">
	<xsl:for-each select="$f-comps">
	  <tr>
	    <td><xsl:value-of select="translate(@id,$lower,$upper)"/></td>
		<td><xsl:apply-templates select="cc:consistency-rationale/node()">
		  <xsl:with-param name="base" select="$short"/>
		</xsl:apply-templates></td>
	  </tr>
	</xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
	<tr><th colspan="2">
	  <xsl:value-of select="$none-msg"/>
	</th></tr>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="cc:base-pp">
    <h2 id="{@short}" class="indexable" data-level="2">
      <xsl:value-of select="@short"/> 
      PP Security Functional Requirements Direction
    </h2>
In a PP-Configuration the includes  <xsl:value-of select="@name"/> PP, the TOE is expected to rely on some of the security functions implemented by the <xsl:value-of select="@product"/> as a whole and evaluated against the Base-PP.
The following sections describe any modifications that the ST author must make to the SFRs
defined in the Base-PP in addition to what is mandated by section 5.4.

    <xsl:element name="h2">
      <xsl:attribute name="id">unmodsfr-<xsl:value-of select="@short"></xsl:value-of></xsl:attribute>
      <xsl:attribute name="class">indexable</xsl:attribute>
      <xsl:attribute name="data-level">3</xsl:attribute>
      Unmodified SFRs
    </xsl:element>
The SFRs listed in this section are defined in the <xsl:value-of select="../cc:base/@short"/> PP and are relevant to the secure operation of the
TOE. 
When testing the TOE, it is necessary to ensure that these SFRs are tested specifically in
conjunction with the <xsl:value-of select="//cc:Module/@name"/> portion of the TOE.
The ST author may complete all selections and assignments in these SFRs without any
additional restrictions.
<ul>
    <!-- 
	 https is apparently not supported by xsltproc and http is not supported by github (where these files are resident).
	 I.E the following does not work
    <xsl:for-each select="document('https://raw.githubusercontent.com/commoncriteria/application/76f9cb4fadb616087626e1bd589a74a3679ced06/input/application.xml')//:f-component"> 
	 Solution: Pre-processes the document and wget the bases and save them to a temporary directory with the filename being the index of the base.
    -->
    <xsl:variable name="redefsec" select="."/>
    <xsl:for-each select="document(concat($basesdir,'/',count(preceding-sibling::*),'.xml'))//cc:f-component">
      <xsl:variable name="baseid" select="@id"/>
      <xsl:if test="not($redefsec//cc:f-component[@id=$baseid])">
	<li><xsl:value-of select="translate(@id,$lower,$upper)"/></li>
      </xsl:if>
    </xsl:for-each>
</ul>
    <xsl:element name="h2">
      <xsl:attribute name="id">modsfr-<xsl:value-of select="@short"></xsl:value-of></xsl:attribute>
      <xsl:attribute name="class">indexable</xsl:attribute>
      <xsl:attribute name="data-level">3</xsl:attribute>
      Modified SFRs
    </xsl:element>
    <xsl:choose><xsl:when test="cc:modified-sfrs//cc:f-component">
      The SFRs listed in this section are defined in the <xsl:value-of select="../cc:base-pp/@name"/> Protection Profile and relevant to the secure operation of the TOE.
    <xsl:apply-templates select="cc:modified-sfrs"/>
    </xsl:when>
    <xsl:otherwise>
      This module does not modify any SFRs defined by the <xsl:value-of select="../cc:base-pp/@name"/> Protection Profile.
    </xsl:otherwise>
    </xsl:choose>

    <xsl:element name="h2">
      <xsl:attribute name="id">addsfr-<xsl:value-of select="@short"></xsl:value-of></xsl:attribute>
      <xsl:attribute name="class">indexable</xsl:attribute>
      <xsl:attribute name="data-level">3</xsl:attribute>
      Additional SFRs
    </xsl:element>
    <xsl:choose><xsl:when test="cc:additional-sfrs">
      This section defines additional SFRs that must be added to the TOE boundary in order to implement the functionality in any PP-Configuration where the <xsl:value-of select="../cc:base-pp/@name"/> Protection Profile is claimed as the Base-PP.
      <xsl:apply-templates select="cc:additional-sfrs"/>
    </xsl:when>
    <xsl:otherwise>
This module does not define any additional SFRs for any PP-Configuration where the <xsl:value-of select="../cc:base-pp/@name"/> Protection Profile is claimed as the Base-PP.
    </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="cc:con-sec-problem">
    <xsl:apply-templates/>
  </xsl:template>



  <xsl:template name="consistency-row">
    <xsl:param name="base"/>
    <xsl:param name="orig"/>
	<tr>
	  <td><xsl:value-of select="$orig/@id"/></td>
	  <!-- if the base has a con-mod equal to the id -->
	  <td><xsl:choose>
	    <xsl:when test="$base/cc:con-mod[@id=$orig/@id]">
	      <xsl:apply-templates select="$base/cc:con-mod[@id=$orig/@id]"/>
	    </xsl:when>
	    <xsl:otherwise>
	      <!-- Can only go one element deep here -->
	      <xsl:apply-templates select="cc:consistency-rationale/node()">
		<xsl:with-param name="base" select="$base/@short"/>
	      </xsl:apply-templates>
	    </xsl:otherwise>
	  </xsl:choose></td>
	</tr>
  </xsl:template>

  <xsl:template match="cc:bibliography">
    <h1 id="bibliography" class="indexable" data-level="A">Bibliography</h1>
    <table>
      <tr class="header">
        <th>Identifier</th>
        <th>Title</th>
      </tr>
      <xsl:apply-templates mode="hook" select="."/>
      <xsl:for-each select="cc:entry">
        <tr>
          <td>
            <xsl:element name="span">
              <xsl:attribute name="id">
                <xsl:value-of select="@id"/>
              </xsl:attribute> [<xsl:value-of select="cc:tag"/>] </xsl:element>
          </td>
          <td>
            <xsl:apply-templates select="cc:description"/>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template match="cc:acronyms">
    <h1 id="bibliography" class="indexable" data-level="A">Acronyms</h1>
    <table>
      <tr class="header">
        <th>Acronym</th>
        <th>Meaning</th>
      </tr>
      <xsl:for-each select="cc:entry">
        <tr>
	  <xsl:for-each select="cc:*"><td><xsl:apply-templates/></td></xsl:for-each>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template name="man-sfrs">
    <h2 id="man-sfrs" class="indexable" data-level="2">TOE Security Functional Requirements</h2>
    <xsl:choose>
      <xsl:when test="cc:f-component">
	The following section describes the SFRs that must be satisfied by any TOE that claims conformance to this PP-Module.
	These SFRs must be claimed regardless of which PP-Configuration is used to define the TOE.
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
	This module does not define any mandatory SFRs.
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="opt-sfrs">
    <h1 id="opt-sfrs" class="indexable" data-level="A">Optional SFRs</h1>
    As indicated in the introduction to this PP-Module, the baseline requirements (those that must be
performed by the TOE or its underlying platform) are contained in the body of this PP-Module.
    Additionally, there are three other types of requirements specified in Appendices A, B, and C.
    The first type (in this Appendix) are requirements that can be included in the ST, but do not have to be in order for a TOE to claim conformance to this PP-Module.
    The second type (in Appendix B) are requirements based on selections in the body of the PP-Module: if certain selections are made, then additional requirements in that appendix will need to be included. The third type (in Appendix C) are components that are not required in order to conform to this PP-Module, but will be included in the baseline requirements in future versions of this PP-Module, so adoption by VPN Client vendors is encouraged.
    Note that the ST author is responsible for ensuring that requirements that may be
    associated with those in Appendix A, Appendix B, and/or Appendix C but are not listed (e.g., FMT-type
    requirements) are also included in the ST.

    <xsl:choose>
      <xsl:when test="//cc:opt-sfrs//cc:f-component">
        <xsl:apply-templates select="//cc:opt-sfrs//cc:f-component"/>
      </xsl:when>
      <xsl:otherwise>
	<p>
	  This module does not define any optional SFRs.
	</p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="sel-sfrs">
    <h1 id="sel-sfrs" class="indexable" data-level="A">Selection-based SFRs</h1>
    As indicated in the introduction to this PP-Module, the baseline requirements (those that must be
    performed by the TOE or its underlying platform) are contained in the body of this PP-Module.
    There are additional requirements based on selections in the body of the PP-Module:
    if certain selections are made, then additional requirements below will need to be included.
    <xsl:choose>
      <xsl:when test="//cc:sel-sfrs//cc:f-component">
        <xsl:apply-templates select="//cc:sel-sfrs//cc:f-component"/>
      </xsl:when>
      <xsl:otherwise>
	<p>
	  This module does not define any selection-based SFRs.
	</p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="obj-sfrs">
    <h1 id="obj-sfrs" class="indexable" data-level="A">Objective SFRs</h1>
    This section is reserved for requirements that are not currently prescribed by this PP-Module 
    but are expected to be included in future versions of the PP-Module.
    Vendors planning on having evaluations performed against future products are encouraged
    to plan for these objective requirements to be met.
    <xsl:choose>
      <xsl:when test="//cc:obj-sfrs//cc:f-component">
        <xsl:apply-templates select="//cc:obj-sfrs//cc:f-component"/>
      </xsl:when>
      <xsl:otherwise>
	<p>
	  This module does not define any objective SFRs.
	</p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="cc:base-name">
    <xsl:param name="base"/>
    <xsl:value-of select="$base"/>
  </xsl:template>


  <xsl:template match="cc:consistency-rationale"/>


  <!--
      Eat all assurance activities
  -->
  <xsl:template match="cc:aactivity">
    <xsl:if test="not($release='final')">
      <div class="activity_pane hide">
	<div class="activity_pane_header">
	  <a onclick="toggle(this);return false;" href="#">
            <span class="activity_pane_label"> Evaluation Activity </span>
            <span class="toggler"/>
	  </a>
	</div>
	<div class="activity_pane_body">
	  <i>
            <xsl:apply-templates/>
	  </i>
	</div>
      </div>
    </xsl:if>
  </xsl:template>




  <xsl:template name="opt_text"/>
</xsl:stylesheet>
