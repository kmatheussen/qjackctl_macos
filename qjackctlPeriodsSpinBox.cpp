// qjackctlPeriodsSpinBox.cpp
//
/****************************************************************************
   Copyright (C) 2003-2020, rncbc aka Rui Nuno Capela. All rights reserved.
   Copyright (C) 2015, Kjetil Matheussen. (portaudio_probe_thread)
   Copyright (C) 2013, Arnout Engelen. All rights reserved.

   This program is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation; either version 2
   of the License, or (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License along
   with this program; if not, write to the Free Software Foundation, Inc.,
   51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

*****************************************************************************/

#include "qjackctlAbout.h"
#include "qjackctlPeriodsSpinBox.h"

#include "qjackctlSetup.h"


// Constructor.
qjackctlPeriodsSpinBox::qjackctlPeriodsSpinBox ( QWidget *pParent )
	: QSpinBox(pParent)
{
}

QString qjackctlPeriodsSpinBox::textFromValue ( int value ) const {
  if (value < 2)
    return "(default)";
  else
    return QString::number(value);
}



// end of qjackctlPeriodsSpinBox.cpp
