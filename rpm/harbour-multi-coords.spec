# 
# Do NOT Edit the Auto-generated Part!
# Generated by: spectacle version 0.32
# 

Name:       harbour-multi-coords

# >> macros
# << macros

Summary:    GMFS - Geocaching Multi Formula Solver
Version:    2.5
Release:    2
Group:      Qt/Qt
License:    LICENSE
BuildArch:  noarch
URL:        http://example.org/
Source0:    %{name}-%{version}.tar.bz2
Source100:  harbour-multi-coords.yaml
Requires:   sailfishsilica-qt5 >= 0.10.9
Requires:   libsailfishapp-launcher
BuildRequires:  pkgconfig(sailfishapp) >= 1.0.3
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  desktop-file-utils

%description
GMFS - Geocaching Multi Formula Solver
Tool intended to help with Geocaching Multis, where you have to collect values
in order to solve formulas for the next coordinates.


%prep
%setup -q -n %{name}-%{version}

# >> setup
# << setup

%build
# >> build pre
# << build pre

%qmake5 

make %{?_smp_mflags}

# >> build post
# << build post

%install
rm -rf %{buildroot}
# >> install pre
# << install pre
%qmake5_install

# >> install post
# << install post

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop

%files
%defattr(-,root,root,-)
%defattr(0644,root,root,-)
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/*/apps/%{name}.png
# >> files
# << files
