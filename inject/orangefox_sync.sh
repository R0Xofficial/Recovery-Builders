#!/bin/bash
# ***************************************************************************************
# - Script to set up things for building OrangeFox with a twrp minimal manifest
# - Syncs the relevant twrp minimal manifest, and patches it for building OrangeFox
# - Pulls in the OrangeFox recovery sources and vendor tree
# - Author:  DarthJabba9 (Modded by: R0Xofficial)
# - Version: generic:024
# - Date:    20 April 2026
# ***************************************************************************************

# the version number of this script
SCRIPT_VERSION="20260420";

# the base version of the current OrangeFox
FOX_BASE_VERSION="R12";

# Our starting point (Fox base dir)
BASE_DIR="$PWD";

# default directory for the new manifest
MANIFEST_DIR="";

# the twrp minimal manifest
MIN_MANIFEST="https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git";

# --- START OF NEW BRANCH FUNCTIONS ---

do_fox_160() {
	MIN_MANIFEST="https://github.com/nebrassy/platform_manifest_twrp_aosp.git";
	BASE_VER=14;
	FOX_BRANCH="fox_16.0";
	FOX_DEF_BRANCH="fox_16.0";
	TWRP_BRANCH="twrp-14";
	DEVICE_BRANCH="android-14";
	TW_DEVICE_BRANCH="android-14.1";
	test_build_device="vayu";
	[ -z "$MANIFEST_DIR" ] && MANIFEST_DIR="$BASE_DIR/$FOX_DEF_BRANCH";
}

do_fox_160_R12() {
	MIN_MANIFEST="https://github.com/nebrassy/platform_manifest_twrp_aosp.git";
	BASE_VER=14;
	FOX_BRANCH="fox_16.0-R12";
	FOX_DEF_BRANCH="fox_16.0";
	TWRP_BRANCH="twrp-14";
	DEVICE_BRANCH="android-14";
	TW_DEVICE_BRANCH="android-14.1";
	test_build_device="vayu";
	[ -z "$MANIFEST_DIR" ] && MANIFEST_DIR="$BASE_DIR/$FOX_DEF_BRANCH";
}

do_fox_141_R12_new() {
	MIN_MANIFEST="https://github.com/nebrassy/platform_manifest_twrp_aosp.git";
	BASE_VER=14;
	FOX_BRANCH="fox_14.1-R12-new";
	FOX_DEF_BRANCH="fox_14.1";
	TWRP_BRANCH="twrp-14";
	DEVICE_BRANCH="android-14";
	TW_DEVICE_BRANCH="android-14.1";
	test_build_device="vayu";
	[ -z "$MANIFEST_DIR" ] && MANIFEST_DIR="$BASE_DIR/$FOX_DEF_BRANCH";
}

do_fox_121_R12_new() {
	BASE_VER=12;
	FOX_BRANCH="fox_12.1-R12-new";
	FOX_DEF_BRANCH="fox_12.1";
	TWRP_BRANCH="twrp-12.1";
	DEVICE_BRANCH="android-12.1";
	TW_DEVICE_BRANCH="android-12.1";
	test_build_device="miatoll";
	[ -z "$MANIFEST_DIR" ] && MANIFEST_DIR="$BASE_DIR/$FOX_DEF_BRANCH";
}

do_fox_121_R12() {
	BASE_VER=12;
	FOX_BRANCH="fox_12.1-R12";
	FOX_DEF_BRANCH="fox_12.1";
	TWRP_BRANCH="twrp-12.1";
	DEVICE_BRANCH="android-12.1";
	TW_DEVICE_BRANCH="android-12.1";
	test_build_device="miatoll";
	[ -z "$MANIFEST_DIR" ] && MANIFEST_DIR="$BASE_DIR/$FOX_DEF_BRANCH";
}

# --- END OF NEW BRANCH FUNCTIONS ---

do_fox_141() {
	MIN_MANIFEST="https://github.com/nebrassy/platform_manifest_twrp_aosp.git";
	BASE_VER=14;
	FOX_BRANCH="fox_14.1";
	FOX_DEF_BRANCH="fox_14.1";
	TWRP_BRANCH="twrp-14";
	DEVICE_BRANCH="android-14";
	TW_DEVICE_BRANCH="android-14.1";
	test_build_device="vayu";
	[ -z "$MANIFEST_DIR" ] && MANIFEST_DIR="$BASE_DIR/$FOX_DEF_BRANCH";
}

do_fox_121() {
	BASE_VER=12;
	FOX_BRANCH="fox_12.1";
	FOX_DEF_BRANCH="fox_12.1";
	TWRP_BRANCH="twrp-12.1";
	DEVICE_BRANCH="android-12.1";
	TW_DEVICE_BRANCH="android-12.1";
	test_build_device="miatoll";
	[ -z "$MANIFEST_DIR" ] && MANIFEST_DIR="$BASE_DIR/$FOX_DEF_BRANCH";
}

# help
help_screen() {
  echo "Script to set up things for building OrangeFox with a twrp minimal manifest";
  echo "Usage = $0 <arguments>";
  echo "Arguments:";
  echo "    -h, -H, --help 			print this help screen and quit";
  echo "    -d, -D, --debug 			debug mode: print each command being executed";
  echo "    -s, -S, --ssh <'0' or '1'>		set 'USE_SSH' to '0' or '1'";
  echo "    -p, -P, --path <absolute_path>	sync the minimal manifest into the directory '<absolute_path>'";
  echo "    -b, -B, --branch <branch>		get the minimal manifest for '<branch>'";
  echo "    	'<branch>' must be one of the following branches:";
  echo "    		16.0";
  echo "    		16.0-R12";
  echo "    		14.1-R12-new";
  echo "    		14.1";
  echo "    		12.1-R12-new";
  echo "    		12.1-R12";
  echo "    		12.1";
  echo "";
  exit 0;
}

#######################################################################
# test the command line arguments
Process_CMD_Line() {
   if [ -z "$1" ]; then
      help_screen;
   fi

   while (( "$#" )); do

        case "$1" in
                -d | -D | --debug)
                        set -o xtrace;
                ;;
                -h | -H | --help)
                        help_screen;
                ;;
                -s | -S | --ssh)
                        shift;
                        [ "$1" = "0" -o "$1" = "1" ] && USE_SSH=$1 || USE_SSH=0;
                ;;
                -p | -P | --path)
                        shift;
                        [ -n "$1" ] && MANIFEST_DIR=$1;
                ;;
                -b | -B | --branch)
                	shift;
			if [ "$1" = "16.0" ]; then
				do_fox_160;
			elif [ "$1" = "16.0-R12" ]; then
				do_fox_160_R12;
			elif [ "$1" = "14.1-R12-new" ]; then
				do_fox_141_R12_new;
			elif [ "$1" = "14.1" ]; then
				do_fox_141;
			elif [ "$1" = "12.1-R12-new" ]; then
				do_fox_121_R12_new;
			elif [ "$1" = "12.1-R12" ]; then
				do_fox_121_R12;
			elif [ "$1" = "12.1" ]; then
				do_fox_121;
			else
				echo "Invalid branch \"$1\". Read the help screen below.";
				echo "";
				help_screen;
			fi
		;;

	esac
      shift
   done

   if [ -z "$FOX_BRANCH" -o -z "$TWRP_BRANCH" -o -z "$DEVICE_BRANCH" -o -z "$FOX_DEF_BRANCH" ]; then
   	echo "No branch has been specified. Read the help screen.";
   	exit 1;
   fi

  if [ -z "$MANIFEST_DIR" ]; then
   	echo "No path has been specified for the manifest.";
   	exit 1;
  fi
}
#######################################################################

abort() {
  echo "$@";
  exit 1;
}

update_environment() {
  SYNC_LOG="$BASE_DIR"/"$FOX_DEF_BRANCH"_"manifest.sav";
  [ -z "$USE_SSH" ] && USE_SSH="0";
  PATCH_FILE="$BASE_DIR/patches/patch-manifest-$FOX_DEF_BRANCH.diff";
  
  # Fallback dla patchy (użyj patchy z bazowych wersji jeśli dedykowane nie istnieją)
  if [ ! -f "$PATCH_FILE" ]; then
     [ "$BASE_VER" = "14" ] && PATCH_FILE="$BASE_DIR/patches/patch-manifest-fox_14.1.diff";
     [ "$BASE_VER" = "12" ] && PATCH_FILE="$BASE_DIR/patches/patch-manifest-fox_12.1.diff";
  fi

  PATCH_VOLD="$BASE_DIR/patches/patch-vold-$FOX_DEF_BRANCH.diff";
  PATCH_REMOVE_MINIMAL="$BASE_DIR/patches/patch-remove-minimal-$FOX_DEF_BRANCH.diff";
  PATCH_UPDATE_ENGINE="$BASE_DIR/patches/patch-update-engine-$FOX_DEF_BRANCH.diff";
  MANIFEST_BUILD_DIR="$MANIFEST_DIR/build";
  MANIFEST_SYSTEM_DIR="$MANIFEST_DIR/system";
  MANIFEST_VOLD_DIR="$MANIFEST_SYSTEM_DIR/vold";
  MANIFEST_UPDATE_ENGINE_DIR="$MANIFEST_SYSTEM_DIR/update_engine";
  MANIFEST_REPO_MANIFESTS_DIR="$MANIFEST_DIR/.repo/manifests";
}

init_script() {
  echo "-- Starting the script ...";
  echo "-- The new build system will be located in \"$MANIFEST_DIR\"";
  mkdir -p $MANIFEST_DIR;
}

get_twrp_minimal_manifest() {
  cd $MANIFEST_DIR;
  echo "-- Initialising the $TWRP_BRANCH minimal manifest repo ...";
  repo init --depth=1 -u $MIN_MANIFEST -b $TWRP_BRANCH;
  echo "-- Syncing repo ...";
  repo sync;
}

patch_minimal_manifest() {
   echo "-- Patching the manifest ...";
   cd $MANIFEST_BUILD_DIR;
   [ -f "$PATCH_FILE" ] && patch -p1 < $PATCH_FILE;
}

clone_fox_recovery() {
local URL="https://gitlab.com/OrangeFox/bootable/Recovery.git";
local BRANCH=$FOX_BRANCH;
   [ "$USE_SSH" = "1" ] && URL="git@gitlab.com:OrangeFox/bootable/Recovery.git";
   mkdir -p $MANIFEST_DIR/bootable;
   cd $MANIFEST_DIR/bootable/;
   [ -d recovery/ ] && rm -rf recovery;
   echo "-- Pulling the OrangeFox recovery sources (Branch: $BRANCH) ...";
   git clone $URL -b $BRANCH recovery;
}

clone_fox_vendor() {
local URL="https://gitlab.com/OrangeFox/vendor/recovery.git";
local BRANCH=$FOX_BRANCH;
   [ "$USE_SSH" = "1" ] && URL="git@gitlab.com:OrangeFox/vendor/recovery.git";
   mkdir -p $MANIFEST_DIR/vendor;
   cd $MANIFEST_DIR/vendor;
   [ -d recovery/ ] && rm -rf recovery;
   echo "-- Pulling the OrangeFox vendor tree (Branch: $BRANCH) ...";
   git clone $URL -b $BRANCH recovery;
}

clone_common() {
   cd $MANIFEST_DIR/;
   if [ ! -d "device/qcom/common" ]; then
	git clone https://github.com/TeamWin/android_device_qcom_common -b $TW_DEVICE_BRANCH device/qcom/common;
   fi
   if [ ! -d "device/qcom/twrp-common" ]; then
   	git clone https://github.com/TeamWin/android_device_qcom_twrp-common -b $DEVICE_BRANCH device/qcom/twrp-common;
   fi
}

WorkNow() {
    Process_CMD_Line "$@";
    update_environment;
    init_script;
    get_twrp_minimal_manifest;
    patch_minimal_manifest;
    clone_common;
    clone_fox_recovery;
    clone_fox_vendor;
    echo "-- Done.";
    exit 0;
}

WorkNow "$@";
