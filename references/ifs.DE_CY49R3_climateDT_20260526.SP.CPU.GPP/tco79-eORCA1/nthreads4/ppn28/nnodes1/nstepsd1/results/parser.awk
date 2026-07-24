# --- state
BEGIN {
  wam=0; wamstep=0; ifs=0; ifsstep=0
}

# --- WAM blocks -----------------------------------------
/THE WAVE MODEL IS CALLED FOR TWO-WAY/ {wam=1; wamstep++; next}
/END OF WAVE MODEL CALL/ {wam=0; next}

wam && /Neutral 10m U/ { V["wam_u"][wamstep*3+0]=$4; V["wam_u"][wamstep*3+1]=$5; V["wam_u"][wamstep*3+2]=$6 }
wam && /Neutral 10m V/ { V["wam_v"][wamstep*3+0]=$4; V["wam_v"][wamstep*3+1]=$5; V["wam_v"][wamstep*3+2]=$6 }
wam && /Air density/   { V["wam_dens"][wamstep*3+0]=$3; V["wam_dens"][wamstep*3+1]=$4; V["wam_dens"][wamstep*3+2]=$5 }
wam && /w\*/           { V["wam_w"][wamstep*3+0]=$2; V["wam_w"][wamstep*3+1]=$3; V["wam_w"][wamstep*3+2]=$4 }
wam && /Sea ice fraction/ { V["wam_ice"][wamstep*3+0]=$4; V["wam_ice"][wamstep*3+1]=$5; V["wam_ice"][wamstep*3+2]=$6 }
wam && /Charnock/      { V["wam_ch"][wamstep*3+0]=$2; V["wam_ch"][wamstep*3+1]=$3; V["wam_ch"][wamstep*3+2]=$4 }

wam && /WAMNORM FOR[ ]*SIGNIFICANT WAVE HEIGHT/ {
  getline line; split(line,A)
  V["wam_swh"][wamstep*3+0]=A[1]; V["wam_swh"][wamstep*3+1]=A[2]; V["wam_swh"][wamstep*3+2]=A[3]
}
wam && /WAMNORM FOR[ ]*WAVE MODEL WIND DIRECTION/ {
  getline line; split(line,A)
  V["wam_wmwd"][wamstep*3+0]=A[1]; V["wam_wmwd"][wamstep*3+1]=A[2]; V["wam_wmwd"][wamstep*3+2]=A[3]
}
wam && /WAMNORM FOR[ ]*WAVE PEAK PERIOD/ {
  getline line; split(line,A)
  V["wam_wpp"][wamstep*3+0]=A[1]; V["wam_wpp"][wamstep*3+1]=A[2]; V["wam_wpp"][wamstep*3+2]=A[3]
}
wam && /WAMNORM FOR[ ]*DRAG COEFFICIENT/ {
  getline line; split(line,A)
  V["wam_dc"][wamstep*3+0]=A[1]; V["wam_dc"][wamstep*3+1]=A[2]; V["wam_dc"][wamstep*3+2]=A[3]
}
wam && /WAMNORM FOR[ ]*WAVE MODEL WIND SPEED/ {
  getline line; split(line,A)
  V["wam_wmws"][wamstep*3+0]=A[1]; V["wam_wmws"][wamstep*3+1]=A[2]; V["wam_wmws"][wamstep*3+2]=A[3]
}

# --- IFS blocks -----------------------------------------
/NORMS AT NSTEP CNT4/ { ifsstep=$5; ifs=1; next}
/Calling radiation scheme/ { ifs=0; next }

ifs && /^ AVE [0-9]/ {
  V["ifs_sp_vort"][ifsstep]=$2
  V["ifs_sp_div"][ifsstep]=$3
  V["ifs_sp_temp"][ifsstep]=$4
  V["ifs_sp_e"][ifsstep]=$5
}

ifs && /^GPNORM[ ]*HUMIDITY/     { getline line; split(line,A); V["ifs_hum"][ifsstep*3+0]=A[1]; V["ifs_hum"][ifsstep*3+1]=A[2]; V["ifs_hum"][ifsstep*3+2]=A[3] }
ifs && /^GPNORM[ ]*LIQUID WATER/ { getline line; split(line,A); V["ifs_liq"][ifsstep*3+0]=A[1]; V["ifs_liq"][ifsstep*3+1]=A[2]; V["ifs_liq"][ifsstep*3+2]=A[3] }
ifs && /^GPNORM[ ]*ICE WATER/    { getline line; split(line,A); V["ifs_ice"][ifsstep*3+0]=A[1]; V["ifs_ice"][ifsstep*3+1]=A[2]; V["ifs_ice"][ifsstep*3+2]=A[3] }
ifs && /^GPNORM[ ]*SNOW/         { getline line; split(line,A); V["ifs_snow"][ifsstep*3+0]=A[1]; V["ifs_snow"][ifsstep*3+1]=A[2]; V["ifs_snow"][ifsstep*3+2]=A[3] }
ifs && /^GPNORM[ ]*RAIN/         { getline line; split(line,A); V["ifs_rain"][ifsstep*3+0]=A[1]; V["ifs_rain"][ifsstep*3+1]=A[2]; V["ifs_rain"][ifsstep*3+2]=A[3] }
ifs && /^GPNORM[ ]*CLOUD FRACTION/ { getline line; split(line,A); V["ifs_cloud"][ifsstep*3+0]=A[1]; V["ifs_cloud"][ifsstep*3+1]=A[2]; V["ifs_cloud"][ifsstep*3+2]=A[3] }
ifs && /^GPNORM[ ]*OZONE/        { getline line; split(line,A); V["ifs_ozone"][ifsstep*3+0]=A[1]; V["ifs_ozone"][ifsstep*3+1]=A[2]; V["ifs_ozone"][ifsstep*3+2]=A[3] }
ifs && /^GPNORM[ ]*TENUNOGW/     { getline line; split(line,A); V["ifs_tenunogw"][ifsstep*3+0]=A[1]; V["ifs_tenunogw"][ifsstep*3+1]=A[2]; V["ifs_tenunogw"][ifsstep*3+2]=A[3] }
ifs && /^GPNORM[ ]*TENVNOGW/     { getline line; split(line,A); V["ifs_tenvnogw"][ifsstep*3+0]=A[1]; V["ifs_tenvnogw"][ifsstep*3+1]=A[2]; V["ifs_tenvnogw"][ifsstep*3+2]=A[3] }

ifs && /^[ ]*HUMIDITY/       { V["ifs_mass_hum"][ifsstep*3+0]=$2; V["ifs_mass_hum"][ifsstep*3+1]=$3; V["ifs_mass_hum"][ifsstep*3+2]=$4 }
ifs && /^[ ]*LIQUID WATER/   { V["ifs_mass_liq"][ifsstep*3+0]=$3; V["ifs_mass_liq"][ifsstep*3+1]=$4; V["ifs_mass_liq"][ifsstep*3+2]=$5 }
ifs && /^[ ]*ICE WATER/      { V["ifs_mass_ice"][ifsstep*3+0]=$3; V["ifs_mass_ice"][ifsstep*3+1]=$4; V["ifs_mass_ice"][ifsstep*3+2]=$5 }
ifs && /^[ ]*SNOW/           { V["ifs_mass_snow"][ifsstep*3+0]=$2; V["ifs_mass_snow"][ifsstep*3+1]=$3; V["ifs_mass_snow"][ifsstep*3+2]=$4 }
ifs && /^[ ]*RAIN/           { V["ifs_mass_rain"][ifsstep*3+0]=$2; V["ifs_mass_rain"][ifsstep*3+1]=$3; V["ifs_mass_rain"][ifsstep*3+2]=$4 }
ifs && /^[ ]*OZONE/          { V["ifs_mass_ozone"][ifsstep*3+0]=$2; V["ifs_mass_ozone"][ifsstep*3+1]=$3; V["ifs_mass_ozone"][ifsstep*3+2]=$4 }

# --- helpers --------------------------------------------
function emit_array_key(key,    first,i) {
  printf "    %s: [ ", key
  first=1
  for (i in V[key]) {
    if (!first) printf ", "
    printf V[key][i]
    first=0
  }
  print " ]"
}

END {
  # Ordered emission to match your desired YAML order
  # (Everything under 'model:' below the 'last_step' line)
  wanted[1]="ifs_sp_e"
  wanted[2]="wam_u"
  wanted[3]="wam_v"
  wanted[4]="ifs_sp_div"
  wanted[5]="wam_w"
  wanted[6]="wam_dens"
  wanted[7]="wam_ch"
  wanted[8]="ifs_sp_vort"
  wanted[9]="wam_ice"
  wanted[10]="ifs_sp_temp"

  for (k=1; k in wanted; k++) {
    key=wanted[k]
    if (key in V) emit_array_key(key)
  }

  # Then any of the remaining parsed vectors, if present (stable extra dump)
  for (v in V) {
    found=0
    for (k=1; k in wanted; k++) if (v==wanted[k]) {found=1; break}
    if (!found) emit_array_key(v)
  }
}
