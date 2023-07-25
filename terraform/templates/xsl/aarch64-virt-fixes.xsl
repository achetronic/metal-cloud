<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output omit-xml-declaration="yes" indent="yes"/>

    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>

    <!-- Fix: Connect cdrom device on SATA instead of IDE bus -->
    <xsl:template match="/domain/devices/disk[@device='cdrom']/target/@bus">
        <xsl:attribute name="bus">
            <xsl:value-of select="'sata'"/>
        </xsl:attribute>
    </xsl:template>

    <!--
        Knowledge:
        For hypervisors which support it, you can change how a PCI Network device's ROM is presented
        to the guest virtual machine.

        The bar attribute can be set to on or off, and determines whether (or not) the device's ROM will be visible
        in the guest virtual machine's memory map.
        (In PCI documentation, the "rombar" setting controls the presence of the Base Address Register for the ROM).

        If no rom bar is specified, the qemu default will be used (older versions of qemu used a default of 'off',
        while newer qemu versions have a default of 'on').

        There is an optional 'file' attribute, that is used to point to a binary file to be presented to the guest
        virtual machine as the device's ROM BIOS. This can be useful to provide an alternative boot ROM for a network device.
        ###

        Context:
        Some ARM64 platforms such as 'Orange Pi 5' are too new yet. Nowadays, it does not exist a specific
        qemu 'machine' for them, so we need to use generic 'virt-XX'. Due to this, some tweaks are needed to tune it.
        ###

        Fix:
        Upstream will use 'virtio-pci' by default for aarch64/virt guests on network devices, but not yet.
        Until fixed, a workaround is disabling 'rombar' for them

        Extra: Remember it's possible to be more specific on selection just changing the 'match' field
        match="/domain/devices/interface[@type='direct']"
    -->
    <!-- Ref: https://access.redhat.com/documentation/es-es/red_hat_enterprise_linux/6/html/virtualization_administration_guide/sub-sub-section-libvirt-dom-xml-devices-interface-rom-bios-configuration -->
    <!-- Ref: https://bugzilla.redhat.com/show_bug.cgi?id=1337510#c14 -->
    <xsl:template match="/domain/devices/interface">
        <!-- Copy the element -->
        <xsl:copy>
            <!-- And everything inside it -->
            <xsl:apply-templates select="@* | *"/>

            <!-- Add new 'rom' node with 'bar=off' attribute -->
            <xsl:element name="rom">
                <xsl:attribute name="bar">off</xsl:attribute>
            </xsl:element>

            <xsl:apply-templates />
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>