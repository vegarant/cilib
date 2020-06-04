function opts = cil_argparse(opts, args);
    if ~isstruct(opts) && ~isobject(opts)
        error('OPTS must be a structure');
    end
    
    if ~iscell(args)
        args = {args};
    end
    
    nbr_args = numel(args);
    if nbr_args == 0
        return;
    end
    
    for i = 1:nbr_args
        if (ischar(args{i}))
            if strcmpi(args{i},'wave_levels')
                if i+1 <= nbr_args
                    if isnumeric(args{i+1})
                        opts.wave_levels = args{i+1};
                    end
                end
            end
        end
        if (ischar(args{i}))
            if strcmpi(args{i},'use_gpu')
                if i+1 <= nbr_args
                    if isnumeric(args{i+1})
                        opts.use_gpu = args{i+1};
                    end
                end
            end
        end
        if (ischar(args{i}))
            if strcmpi(args{i},'nesta_mu')
                if i+1 <= nbr_args
                    if isnumeric(args{i+1})
                        opts.nesta_mu = args{i+1};
                    end
                end
            end
        end
        if (ischar(args{i}))
            if strcmpi(args{i},'nesta_verbose')
                if i+1 <= nbr_args
                    if isnumeric(args{i+1})
                        opts.nesta_verbose = args{i+1};
                    end
                end
            end
        end
        if (ischar(args{i}))
            if strcmpi(args{i},'spgl1_iterations')
                if i+1 <= nbr_args
                    if isnumeric(args{i+1})
                        opts.iterations = args{i+1};
                    end
                end
            end
        end
        if (ischar(args{i}))
            if strcmpi(args{i},'spgl1_verbosity')
                if i+1 <= nbr_args
                    if isnumeric(args{i+1})
                        opts.verbosity = args{i+1};
                    end
                end
            end
        end
        if (ischar(args{i}))
            if strcmpi(args{i},'measurement_noise')
                if i+1 <= nbr_args
                    if isnumeric(args{i+1})
                        opts.measurement_noise = args{i+1};
                    end
                end
            end
        end
    end
    

end

